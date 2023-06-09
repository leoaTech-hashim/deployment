--
-- mcnekeaetyapwhQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_delete_global_settings(); Type: FUNCTION; Schema: public; Owner: mcnekeaetyapwh
--

CREATE FUNCTION public.add_delete_global_settings() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create a row in emp_audit to reflect the operation performed on emp,
        -- making use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = 'DELETE') THEN
            DELETE FROM global_settings WHERE shop_id = OLD.shop;
        ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO global_settings (shop_id, facebook_link, instagram_link, discord_link, snapchat_link, tiktok_link, twitter_link, 
										 show_discord_link, show_facebook_link, show_instagram_link, show_snapchat_link, show_tiktok_link, show_twitter_link, collect_phone, 
										 share_discord_message, share_discord_referral, share_email_message, share_email_referral, share_facebook_message, share_facebook_referral, 
										 share_instagram_message, share_instagram_referral, share_snapchat_message, share_snapchat_referral, share_tiktok_message, share_tiktok_referral, 
										 share_twitter_message, share_twitter_referral, share_whatsapp_message, share_whatsapp_referral, 
										 discount_type, reward_1_code, reward_1_discount, reward_1_tier, reward_2_code, reward_2_discount, reward_2_tier,
										 double_opt_in, double_opt_in_email, referral_email, reward_email, welcome_email, klaviyo_integration)
			SELECT NEW.shop , facebook_link, instagram_link, discord_link, snapchat_link, tiktok_link, twitter_link, 
										 show_discord_link, show_facebook_link, show_instagram_link, show_snapchat_link, show_tiktok_link, show_twitter_link, collect_phone, 
										 share_discord_message, share_discord_referral, share_email_message, share_email_referral, share_facebook_message, share_facebook_referral, 
										 share_instagram_message, share_instagram_referral, share_snapchat_message, share_snapchat_referral, share_tiktok_message, share_tiktok_referral, 
										 share_twitter_message, share_twitter_referral, share_whatsapp_message, share_whatsapp_referral, 
										 discount_type, reward_1_code, reward_1_discount, reward_1_tier, reward_2_code, reward_2_discount, reward_2_tier,
										 double_opt_in, double_opt_in_email, referral_email, reward_email, welcome_email, klaviyo_integration From global_settings where id=1;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.add_delete_global_settings() OWNER TO mcnekeaetyapwh;

--
-- Name: findreferrals(character varying, character, integer); Type: FUNCTION; Schema: public; Owner: mcnekeaetyapwh
--

CREATE FUNCTION public.findreferrals(a character varying, b character, c integer) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
ret RECORD;
code TEXT;
cr INTEGER;
BEGIN
SELECT referral_code INTO code FROM referrals where email = a and campaign_id = c;
IF (code IS NOT NULL) THEN
SELECT code, COALESCE(count(*),0) FROM referrals WHERE referrer_id = code INTO ret;
END IF;
RETURN ret;
END;
$$;


ALTER FUNCTION public.findreferrals(a character varying, b character, c integer) OWNER TO mcnekeaetyapwh;

--
-- Name: gen_random_bytes(integer); Type: FUNCTION; Schema: public; Owner: mcnekeaetyapwh
--

CREATE FUNCTION public.gen_random_bytes(integer) RETURNS bytea
    LANGUAGE sql
    SET search_path TO 'pg_catalog'
    AS $_$
    SELECT decode(string_agg(lpad(to_hex(width_bucket(random(), 0, 1, 256)-1),2,'0') ,''), 'hex')
    FROM generate_series(1, $1);
$_$;


ALTER FUNCTION public.gen_random_bytes(integer) OWNER TO mcnekeaetyapwh;

--
-- Name: random_string(integer); Type: FUNCTION; Schema: public; Owner: mcnekeaetyapwh
--

CREATE FUNCTION public.random_string(len integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
  chars text[] = '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
  result text = '';
  i int = 0;
  rand bytea;
begin
  -- generate secure random bytes and convert them to a string of chars.
  rand = gen_random_bytes($1);
  for i in 0..len-1 loop
    -- rand indexing is zero-based, chars is 1-based.
    result = result || chars[1 + (get_byte(rand, i) % array_length(chars, 1))];
  end loop;
  return result;
end;
$_$;


ALTER FUNCTION public.random_string(len integer) OWNER TO mcnekeaetyapwh;

--
-- Name: unique_random(integer, text, text); Type: FUNCTION; Schema: public; Owner: mcnekeaetyapwh
--

CREATE FUNCTION public.unique_random(len integer, _table text, _col text) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
  result text;
  numrows int;
begin
  result = random_string(len);
  loop
    execute format('select 1 from %I where %I = %L', _table, _col, result);
    get diagnostics numrows = row_count;
    if numrows = 0 then
      return result; 
    end if;
    result = random_string(len);
  end loop;
end;
$$;


ALTER FUNCTION public.unique_random(len integer, _table text, _col text) OWNER TO mcnekeaetyapwh;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: campaign_settings; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.campaign_settings (
    campaign_id integer NOT NULL,
    collect_phone boolean,
    discord_link text,
    double_opt_in boolean,
    double_opt_in_email text,
    end_date timestamp with time zone NOT NULL,
    facebook_link text,
    instagram_link text,
    klaviyo_integration boolean,
    klaviyo_list_id text,
    name character varying NOT NULL,
    product text NOT NULL,
    referral_email text,
    reward_1_code text NOT NULL,
    reward_1_discount smallint NOT NULL,
    reward_1_tier smallint NOT NULL,
    reward_2_code text NOT NULL,
    reward_2_discount smallint NOT NULL,
    reward_2_tier smallint NOT NULL,
    reward_3_code text,
    reward_3_discount smallint,
    reward_3_tier smallint,
    reward_4_code text,
    reward_4_discount smallint,
    reward_4_tier smallint,
    reward_email text,
    share_discord_message text,
    share_discord_referral boolean,
    share_email_message text,
    share_email_referral boolean,
    share_facebook_message text,
    share_facebook_referral boolean,
    share_instagram_message text,
    share_instagram_referral boolean,
    share_snapchat_message text,
    share_snapchat_referral boolean,
    share_tiktok_message text,
    share_tiktok_referral boolean,
    share_twitter_message text,
    share_twitter_referral boolean,
    share_whatsapp_message text,
    share_whatsapp_referral boolean,
    shop_id character varying NOT NULL,
    show_discord_link boolean,
    show_facebook_link boolean,
    show_instagram_link boolean,
    show_snapchat_link boolean,
    show_tiktok_link boolean,
    show_twitter_link boolean,
    snapchat_link text,
    start_date timestamp with time zone NOT NULL,
    tiktok_link text,
    twitter_link text,
    welcome_email text,
    template_id integer NOT NULL,
    discount_type character varying NOT NULL
);


ALTER TABLE public.campaign_settings OWNER TO mcnekeaetyapwh;

--
-- Name: campaign_settings_campaign_id_seq; Type: SEQUENCE; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE public.campaign_settings ALTER COLUMN campaign_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.campaign_settings_campaign_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: global_settings; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.global_settings (
    id integer NOT NULL,
    shop_id character varying NOT NULL,
    facebook_link text,
    instagram_link text,
    discord_link text,
    snapchat_link text,
    tiktok_link text,
    twitter_link text,
    show_discord_link boolean,
    show_facebook_link boolean,
    show_instagram_link boolean,
    show_snapchat_link boolean,
    show_tiktok_link boolean,
    show_twitter_link boolean,
    collect_phone boolean,
    share_discord_message text,
    share_discord_referral boolean,
    share_email_message text,
    share_email_referral boolean,
    share_facebook_message text,
    share_facebook_referral boolean,
    share_instagram_message text,
    share_instagram_referral boolean,
    share_snapchat_message text,
    share_snapchat_referral boolean,
    share_tiktok_message text,
    share_tiktok_referral boolean,
    share_twitter_message text,
    share_twitter_referral boolean,
    share_whatsapp_message text,
    share_whatsapp_referral boolean,
    discount_type character varying NOT NULL,
    reward_1_code text NOT NULL,
    reward_1_discount smallint NOT NULL,
    reward_1_tier smallint NOT NULL,
    reward_2_code text NOT NULL,
    reward_2_discount smallint NOT NULL,
    reward_2_tier smallint NOT NULL,
    reward_3_code text,
    reward_3_discount smallint,
    reward_3_tier smallint,
    reward_4_code text,
    reward_4_discount smallint,
    reward_4_tier smallint,
    double_opt_in boolean,
    double_opt_in_email text,
    referral_email text,
    reward_email text,
    welcome_email text,
    klaviyo_integration boolean,
    klaviyo_api_key text,
    templates text
);


ALTER TABLE public.global_settings OWNER TO mcnekeaetyapwh;

--
-- Name: global_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE public.global_settings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.global_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ip_addresses; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.ip_addresses (
    address character varying(255) NOT NULL,
    count_ip integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    id integer NOT NULL,
    campaign_id integer NOT NULL
);


ALTER TABLE public.ip_addresses OWNER TO mcnekeaetyapwh;

--
-- Name: ip_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE public.ip_addresses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ip_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.referrals (
    referral_code character(8) DEFAULT public.unique_random(8, 'referrals'::text, 'referral_code'::text) NOT NULL,
    email character varying(255) NOT NULL,
    referrer_id character(8),
    created_at timestamp with time zone DEFAULT now(),
    campaign_id integer,
    reward_code_1_used boolean,
    reward_code_1 text,
    reward_code_2_used boolean,
    reward_code_2 text,
    reward_code_3 text,
    reward_code_3_used boolean,
    reward_code_4_used boolean,
    reward_code_4 text,
    revenue numeric
);


ALTER TABLE public.referrals OWNER TO mcnekeaetyapwh;

--
-- Name: shopify_sessions; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.shopify_sessions (
    id character varying(255) NOT NULL,
    shop character varying(255) NOT NULL,
    state character varying(255) NOT NULL,
    isonline boolean NOT NULL,
    expires integer,
    scope character varying(255),
    accesstoken character varying(255),
    onlineaccessinfo character varying(255)
);


ALTER TABLE public.shopify_sessions OWNER TO mcnekeaetyapwh;

--
-- Name: template_landing_page; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.template_landing_page (
    id integer NOT NULL,
    campaign_name character varying NOT NULL,
    show_header_footer boolean NOT NULL,
    background_image text,
    base_text_size smallint,
    header_text text,
    pre_header_text text,
    tag_line_text text,
    button_text text,
    email_placeholder_text text,
    second_page text,
    main_color character varying(9),
    accent_color character varying(9),
    text_position text,
    input_position text,
    divider character varying,
    background_overlay text,
    phone_placeholder_text text
);


ALTER TABLE public.template_landing_page OWNER TO mcnekeaetyapwh;

--
-- Name: template_landing_page_id_seq; Type: SEQUENCE; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE public.template_landing_page ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.template_landing_page_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: template_rewards_page; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.template_rewards_page (
    id integer NOT NULL,
    show_header_footer boolean,
    background_image text,
    base_text_size smallint,
    pre_header_text text,
    header_text text,
    sub_header_text text,
    first_page text NOT NULL,
    rewards_image text NOT NULL,
    main_color character varying(9),
    accent_color character varying(9),
    referral_position text,
    reward_position text,
    divider character varying,
    campaign_name character varying,
    background_overlay text
);


ALTER TABLE public.template_rewards_page OWNER TO mcnekeaetyapwh;

--
-- Name: template_rewards_page_id_seq; Type: SEQUENCE; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE public.template_rewards_page ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.template_rewards_page_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 2
);


--
-- Name: templates; Type: TABLE; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TABLE public.templates (
    id integer NOT NULL,
    landing_template_id integer NOT NULL,
    rewards_template_id integer NOT NULL,
    campaign_image text
);


ALTER TABLE public.templates OWNER TO mcnekeaetyapwh;

--
-- Name: templates_id_seq; Type: SEQUENCE; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE public.templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 2
);


--
-- Data for Name: campaign_settings; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.campaign_settings OVERRIDING SYSTEM VALUE VALUES (1, false, NULL, NULL, NULL, '2023-03-11 12:48:18.354439+05', NULL, NULL, NULL, NULL, 'undefined', 'some product', NULL, '05OFF', 5, 5, '10OFF', 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'leoaxychros.myshopify.com', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-03-06 12:48:18.354439+05', NULL, NULL, NULL, 1, 'percent');


--
-- Data for Name: global_settings; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.global_settings OVERRIDING SYSTEM VALUE VALUES (1, 'default', 'https://www.facebook.com/', 'https://www.instgram.com/', 'https://www.discord.com/server', 'https://www.snapchat.com/', 'https://www.tiktok.com/', 'https://www.twitter.com/', true, true, true, true, true, true, false, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'percent', '05OFF', 5, 5, '10OFF', 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, false, '', 'Hi, You have a referral', 'Hi , You have earned a reward', 'Hi, Welcome to the program', false, NULL, NULL);
INSERT INTO public.global_settings OVERRIDING SYSTEM VALUE VALUES (7, 'storetasker-sughra.myshopify.com', 'https://www.facebook.com/', 'https://www.instgram.com/', 'https://www.discord.com/server', 'https://www.snapchat.com/', 'https://www.tiktok.com/', 'https://www.twitter.com/', true, true, true, true, true, true, false, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'percent', '05OFF', 5, 5, '10OFF', 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, false, '', 'Hi, You have a referral', 'Hi , You have earned a reward', 'Hi, Welcome to the program', false, NULL, NULL);
INSERT INTO public.global_settings OVERRIDING SYSTEM VALUE VALUES (8, 'leoaxychros.myshopify.com', 'https://www.facebook.com/', 'https://www.instgram.com/', 'https://www.discord.com/server', 'https://www.snapchat.com/', 'https://www.tiktok.com/', 'https://www.twitter.com/', true, true, true, true, true, true, false, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'Use my Referral', true, 'percent', '05OFF', 5, 5, '10OFF', 10, 10, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, 'Hi, You have a referral', 'Hi , You have earned a reward', 'Hi, Welcome to the program', false, NULL, NULL);


--
-- Data for Name: ip_addresses; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.ip_addresses OVERRIDING SYSTEM VALUE VALUES ('111.119.183.27', 1, '2023-03-21 18:14:28.33366', '2023-03-21 18:14:28.33366', 3, 1);
INSERT INTO public.ip_addresses OVERRIDING SYSTEM VALUE VALUES ('111.119.183.14', 7, '2023-03-22 10:51:13.143082', '2023-03-22 11:13:18.36685', 4, 1);


--
-- Data for Name: referrals; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.referrals VALUES ('d5ItPXbX', 'sughra.mehdi@gmail.com', 'abcdef12', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.referrals VALUES ('pP6re383', 'hello@dabbadrop.co.uk', 'd5ItPXbX', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.referrals VALUES ('fFtjKyLd', 'techdabiyo@gmail.com', 'd5ItPXbX', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.referrals VALUES ('a7uVLxEk', 'sughra@leoatech.com', 'fFtjKyLd', '2023-03-22 10:51:13.146774+05', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public.referrals VALUES ('fqvIf2sl', 'sughra.mehdi@storetasker.com', 'fFtjKyLd', '2023-03-22 10:51:42.840951+05', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: shopify_sessions; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.shopify_sessions VALUES ('offline_munch-fit-uk.myshopify.com', 'munch-fit-uk.myshopify.com', 'offline_693306731481567', false, NULL, 'write_products', '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', NULL);
INSERT INTO public.shopify_sessions VALUES ('offline_musafirat.myshopify.com', 'musafirat.myshopify.com', 'offline_858101671521210', false, NULL, 'read_orders,read_products,write_content,write_themes', 'shpua_43c8b5f8176d002fe654862ed2d0b5ee', NULL);
INSERT INTO public.shopify_sessions VALUES ('offline_leoaxychros.myshopify.com', 'leoaxychros.myshopify.com', 'offline_387141865025516', false, NULL, 'read_orders,read_products,write_content,write_themes', 'shpua_8bfb4b963f3f3a918cf57e37cb01cac5', NULL);
INSERT INTO public.shopify_sessions VALUES ('offline_storetasker-sughra.myshopify.com', 'storetasker-sughra.myshopify.com', 'offline_993059612374174', false, NULL, 'read_orders,read_products,write_content,write_themes', 'shpua_f375596c23aa4f373de3f01d46441029', NULL);


--
-- Data for Name: template_landing_page; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (7, 'Basic2', false, NULL, 14, 'This is header', 'This is preheader', 'This is tagline', 'Enter', 'Enter Email', 'second-page', '000000', 'ffffff', NULL, NULL, 'horizontal', 'linear-gradient(#ffffff, #000000)', NULL);
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (8, 'Basic3', false, NULL, 14, 'This is header', 'This is preheader', 'This is tagline', 'Enter', 'Enter Email', 'second-page', '000000', 'ffffff', NULL, NULL, 'vertical', 'linear-gradient(#ffffff, #000000)', NULL);
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (1, 'Basic', false, NULL, 14, 'Enter Header Text', 'Enter PreHeader Text', 'Enter Your Business TagLine', 'Enter', 'Enter Email', 'second-page', '000000', 'FFFFFF', NULL, NULL, 'none', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )', NULL);
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (2, 'Food', false, 'food', 64, 'Your Health Regime Starts Soon', 'The Wait is About to End', NULL, 'Tell Me First', 'Email', 'second-page', '000000', 'ffffff', NULL, NULL, 'none', 'linear-gradient(rgba(0, 0, 0, 0.3), rgba(0,0,0, 0.3) )', 'Number');
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (3, 'Food2', false, 'food', 64, 'Your Health Regime Starts Soon', 'The Wait is About to End', NULL, 'Tell Me First', 'Email', 'second-page', '127636', 'ffffff', NULL, NULL, 'none', 'linear-gradient(rgba(0, 0, 0, 0.3), rgba(0,0,0, 0.3) )', 'Number');
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (4, 'Nature', false, 'nature2', 64, 'Designing the Future', NULL, NULL, 'Take me too!', 'Email', 'second-page', 'ffffff', '000000', NULL, NULL, 'none', 'linear-gradient(#ffffff, #000000)', 'Phone Number');
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (5, 'Clothing', false, 'clothing', 64, 'Sign Up to Rediscover Yourself', NULL, NULL, 'I am in!', 'Your Email', 'second-page', '000000', 'ffffff', NULL, NULL, 'diagonal', 'linear-gradient(#ffffff, #000000)', NULL);
INSERT INTO public.template_landing_page OVERRIDING SYSTEM VALUE VALUES (6, 'Jewelry', false, 'jewelry2', 64, 'Get Classy With Us', NULL, NULL, 'Let me in First!', 'Email', 'second-page', '000000', 'ffffff', NULL, NULL, 'vertical', 'linear-gradient(#ffffff, #000000)', 'Phone Number');


--
-- Data for Name: template_rewards_page; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (6, false, 'jewelry2', 64, NULL, 'Your Store', 'Share your unique link via email, Facebook or Twitter and earn goodies for each friend who signs up!', 'first-page', 'image-6', '000000', 'ffffff', NULL, NULL, 'vertical', 'Jewelry', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (7, false, NULL, 14, 'This is Preheader Text', 'This is Header Text', 'This is Sub Header Text', 'first-page', 'icon-3', '000000', 'ffffff', NULL, NULL, 'horizontal', 'Basic2', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (8, false, NULL, 14, 'This is Preheader Text', 'This is Header Text', 'This is Sub Header Text', 'first-page', 'icon-3', '000000', 'ffffff', NULL, NULL, 'vertical', 'Basic3', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (2, false, 'food', 64, NULL, 'Your Product', 'Share your unique link via email, Facebook or Twitter and earn goodies for each friend who signs up!', 'first-page', 'icon-7', '000000', 'ffffff', NULL, NULL, 'none', 'Food', 'linear-gradient(rgba(0, 0, 0, .3), rgba(0,0,0, .3) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (3, false, 'food', 64, NULL, 'Your Product', 'Share your unique link via email, Facebook or Twitter and earn goodies for each friend who signs up!', 'first-page', 'icon-7', '127636', 'ffffff', NULL, NULL, 'none', 'Food2', 'linear-gradient(rgba(0, 0, 0, .3), rgba(0,0,0, .3) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (1, false, NULL, 12, NULL, NULL, NULL, 'first-page', 'image-1', '000000', 'ffffff', NULL, NULL, 'none', 'Basic', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (4, false, 'nature2', 64, NULL, 'Your Product', 'Share your unique link via email, Facebook or Twitter and earn goodies for each friend who signs up!', 'first-page', 'image-9', 'ffffff', '000000', NULL, NULL, 'none', 'Nature', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )');
INSERT INTO public.template_rewards_page OVERRIDING SYSTEM VALUE VALUES (5, false, 'clothing', 64, NULL, 'Rediscover Yourself', 'Share your unique link via email, Facebook or Twitter and earn goodies for each friend who signs up!', 'first-page', 'icon-6', '000000', 'ffffff', NULL, NULL, 'horizontal', 'Clothing', 'linear-gradient(rgba(0, 0, 0, 0), rgba(0,0,0, 0) )');


--
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: mcnekeaetyapwh
--

INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (1, 1, 1, NULL);
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (7, 7, 7, NULL);
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (8, 8, 8, NULL);
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (2, 2, 2, 'WelcomeFood');
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (3, 3, 3, 'WelcomeFood2');
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (4, 4, 4, 'WelcomeNature');
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (5, 5, 5, 'WelcomeClothing');
INSERT INTO public.templates OVERRIDING SYSTEM VALUE VALUES (6, 6, 6, 'WelcomeJewelry');


--
-- Name: campaign_settings_campaign_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mcnekeaetyapwh
--

SELECT pg_catalog.setval('public.campaign_settings_campaign_id_seq', 1, false);


--
-- Name: global_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mcnekeaetyapwh
--

SELECT pg_catalog.setval('public.global_settings_id_seq', 8, true);


--
-- Name: ip_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mcnekeaetyapwh
--

SELECT pg_catalog.setval('public.ip_addresses_id_seq', 4, true);


--
-- Name: template_landing_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mcnekeaetyapwh
--

SELECT pg_catalog.setval('public.template_landing_page_id_seq', 8, true);


--
-- Name: template_rewards_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mcnekeaetyapwh
--

SELECT pg_catalog.setval('public.template_rewards_page_id_seq', 9, true);


--
-- Name: templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mcnekeaetyapwh
--

SELECT pg_catalog.setval('public.templates_id_seq', 9, true);


--
-- Name: campaign_settings campaign_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.campaign_settings
    ADD CONSTRAINT campaign_settings_pkey PRIMARY KEY (campaign_id);


--
-- Name: global_settings global_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.global_settings
    ADD CONSTRAINT global_settings_pkey PRIMARY KEY (id);


--
-- Name: ip_addresses ip_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.ip_addresses
    ADD CONSTRAINT ip_addresses_pkey PRIMARY KEY (id);


--
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (referral_code);


--
-- Name: shopify_sessions shopify_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.shopify_sessions
    ADD CONSTRAINT shopify_sessions_pkey PRIMARY KEY (id);


--
-- Name: template_landing_page template_landing_page_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.template_landing_page
    ADD CONSTRAINT template_landing_page_pkey PRIMARY KEY (id);


--
-- Name: template_rewards_page template_rewards_page_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.template_rewards_page
    ADD CONSTRAINT template_rewards_page_pkey PRIMARY KEY (id);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- Name: shopify_sessions a_d_global_settings; Type: TRIGGER; Schema: public; Owner: mcnekeaetyapwh
--

CREATE TRIGGER a_d_global_settings AFTER INSERT OR DELETE ON public.shopify_sessions FOR EACH ROW EXECUTE FUNCTION public.add_delete_global_settings();


--
-- Name: ip_addresses campaign_id; Type: FK CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.ip_addresses
    ADD CONSTRAINT campaign_id FOREIGN KEY (campaign_id) REFERENCES public.campaign_settings(campaign_id) NOT VALID;


--
-- Name: referrals campaignid; Type: FK CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT campaignid FOREIGN KEY (campaign_id) REFERENCES public.campaign_settings(campaign_id) NOT VALID;


--
-- Name: templates landing_template; Type: FK CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT landing_template FOREIGN KEY (landing_template_id) REFERENCES public.template_landing_page(id) NOT VALID;


--
-- Name: templates rewards_template; Type: FK CONSTRAINT; Schema: public; Owner: mcnekeaetyapwh
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT rewards_template FOREIGN KEY (rewards_template_id) REFERENCES public.template_rewards_page(id) NOT VALID;


--
-- mcnekeaetyapwhQL database dump complete
--

