import SummaryCard from "../ui/SummaryCard";
import "./home.css";
import { Marketing, Sale, subscriber, arrow } from "../../assets/index";
import Charts from "../ui/Charts";
import React, { useState, useEffect, Fragment, useContext } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  fetchAllCampaigns,
} from "../../app/features/campaigns/campaignSlice";
import CountUp from "react-countup";

const HomeComponent = () => {
  const List = useSelector(fetchAllCampaigns);
  const [getCampaigns, setCampaigns] = useState([]);

  useEffect(() => {
    if (List) {
      setCampaigns(List);
    }
  }, [List]);

  const LineChartOptions = {
    responsive: true,
    animation: {
      easing: "easeInOutQuad",
      duration: 520,
    },
    scales: {
      x: {
        grid: {
          color: "#fff",
        },
        ticks: {
          color: "#fff",
        },
      },
      y: {
        border: {
          display: true,
        },
        grid: {
          color: "#fff",
        },
        ticks: {
          color: "#fff",
          crossAlign: "far",
          beginAtZero: true,
        },
      },
    },
    elements: {
      line: {
        tension: 0.05,
      },
    },
    legend: {
      display: false,
    },
    point: {
      backgroundColor: "white",
    },
    tooltips: {
      titleFontFamily: "Open Sans",
      backgroundColor: "rgba(0,0,0,0.3)",
      titleFontColor: "red",
      caretSize: 5,
      cornerRadius: 2,
      xPadding: 10,
      yPadding: 10,
    },
    labels: {
      color: "#FFFFFF",

      // This more specific font property overrides the global property
      font: {
        size: 14,
      },
    },
    plugins: {
      filler: {
        propagate: true,
      },
      legend: {
        position: "bottom",
        labels: {
          color: "#FFFFFF",

          // This more specific font property overrides the global property
          font: {
            size: 14,
          },
        },
      },
      title: {
        display: false,
      },
    },
  };

  const LineChartData = {
    labels: ["January", "February", "March", "April", "May", "June", "July"],
    datasets: [
      {
        label: "Clicks",
        data: [11, 73, 56, 32, 45, 9, 112],
        borderColor: "#5447df",
        backgroundColor: "#5447df",
        borderDash: [10, 5],
        fill: "",
      },

      {
        label: "Campaigns",
        data: [45, -23, 89, 23, 110, 34, 65],
        borderColor: "#E0777D",
        backgroundColor: "#E0777D",
        fill: "+2",
      },
      {
        label: "Referrals",
        data: [21, 34, 61, 38, 45, 87, 12],
        borderColor: "#A1F6F5",
        backgroundColor: "#A1F6F5",
        fill: "origin",
      },
    ],
  };

  const DonutChartOptions = {
    responsive: true,
    plugins: {
      legend: {
        position: "right",
        labels: {
          color: "#FFFFFF",

          // This more specific font property overrides the global property
          font: {
            size: 14,
          },
        },
      },
      title: {
        display: false,
      },
    },
  };

  const DonutChartData = {
    labels: ["Product 1", "product 2", "Product 3", "Product 4"],
    datasets: [
      {
        label: "# of Votes",
        data: [30, 20, 10, 5],
        backgroundColor: ["#FFFF8F", "#A1F6F5", "#F56680", "#5447df"],
        borderColor: ["#FFFF8F", "#A1F6F5", "#F56680", "#5447df"],
        borderWidth: 1,
      },
    ],
  };

  const RadarChartOptions = {
    responsive: true,

    scales: {
      r: {
        angleLines: {
          display: false,
        },
        elements: {
          line: {
            borderWidth: 3,
          },
        },
        grid: {
          color: "#fff",
        },
        pointLabels: {
          color: "#fff",
        },
        ticks: {
          color: "#fff",
          backdropColor: "transparent",
          fontWeight: "bold",
        },
      },
    },

    plugins: {
      legend: {
        position: "right",

        labels: {
          color: "#FFFFFF",
          font: {
            size: 14,
          },
        },
      },
      title: {
        display: false,
      },
    },
  };

  const RadarChartData = {
    labels: ["January", "February", "March", "April", "May", "June", "July"],
    datasets: [
      {
        label: "Referrals",
        data: [1, 3, 56, 78, 55, 23, 98],
        borderColor: "rgba(161, 246, 245, 0.7)",
        backgroundColor: "rgba(161, 246, 245, 0.6)",
      },
      {
        label: "Revenue",
        data: [11, 53, 26, 38, 43, 67, 23],
        borderColor: "rgba(245, 102, 128, 0.8)",
        backgroundColor: "rgba(245, 102, 128, 0.5)",
      },
      {
        label: "Clicks",
        data: [86, 78, 65, 59, 65, 99],
        borderColor: "rgba(84, 71, 223, 0.7)",
        backgroundColor: "rgba(84, 71, 223, 0.4)",
      },
    ],
  };

  return (
    <div className="home-container">
      <div className="summary-blocks">
        <SummaryCard
          value={<CountUp start={0} end={getCampaigns.length} duration={1.4} />}
          title="Campaigns"
          icon={Marketing}
          class="campaign-icon"
        />
        <SummaryCard
          value="543678"
          title="Referrals"
          icon={subscriber}
          class="referral-icon"
        />
        <SummaryCard
          value="$253,467"
          title="Revenue"
          icon={Sale}
          class="revenue-icon"
        />
        <SummaryCard
          value="4551678"
          title="Clicks"
          icon={arrow}
          class="clicks-icon"
        />
      </div>

      {/* Charts */}
      <div className="single-chart">
        <Charts
          type="line"
          header="Total Revenue"
          value="$253467"
          subheader="Last 7 months Data"
          LineChartOptions={LineChartOptions}
          LineChartData={LineChartData}
        />
      </div>
      <div className="dual-charts">
        <Charts
          type="radar"
          header="Product Launch"
          value="$2456.76"
          subheader="August 1st, 2022 - September 5th, 2022"
          RadarChartOptions={RadarChartOptions}
          RadarChartData={RadarChartData}
        />
        <Charts
          type="donut"
          header="Revenue"
          value="$15,456.98"
          subheader="Last 4 campaigns"
          DonutChartOptions={DonutChartOptions}
          DonutChartData={DonutChartData}
        />
      </div>
    </div>
  );
};

export default HomeComponent;
