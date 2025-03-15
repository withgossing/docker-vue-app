<template>
  <div>
    <BarChart
      class="h-full w-full"
      :chartData="chartData"
      :options="chartOptions"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { BarChart } from 'vue-chart-3';
import { Chart, registerables } from 'chart.js';

// Chart.js 컴포넌트 등록
Chart.register(...registerables);

// 차트 데이터
const visitorsData = ref([
  { day: '월', desktop: 1200, mobile: 800, tablet: 300 },
  { day: '화', desktop: 1300, mobile: 850, tablet: 320 },
  { day: '수', desktop: 1400, mobile: 900, tablet: 350 },
  { day: '목', desktop: 1350, mobile: 950, tablet: 330 },
  { day: '금', desktop: 1500, mobile: 1000, tablet: 370 },
  { day: '토', desktop: 1650, mobile: 1200, tablet: 420 },
  { day: '일', desktop: 1550, mobile: 1100, tablet: 400 }
]);

// Chart.js에 맞는 데이터 형식으로 변환
const chartData = computed(() => ({
  labels: visitorsData.value.map(item => item.day),
  datasets: [
    {
      label: '데스크톱',
      backgroundColor: 'rgba(71, 183, 132, 0.8)',
      data: visitorsData.value.map(item => item.desktop)
    },
    {
      label: '모바일',
      backgroundColor: 'rgba(53, 162, 235, 0.8)',
      data: visitorsData.value.map(item => item.mobile)
    },
    {
      label: '태블릿',
      backgroundColor: 'rgba(255, 205, 86, 0.8)',
      data: visitorsData.value.map(item => item.tablet)
    }
  ]
}));

// 차트 옵션
const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      position: 'top' as const,
      labels: {
        boxWidth: 12
      }
    },
    tooltip: {
      callbacks: {
        label: function(context: any) {
          let label = context.dataset.label || '';
          if (label) {
            label += ': ';
          }
          if (context.parsed.y !== null) {
            label += context.parsed.y.toLocaleString() + '명';
          }
          return label;
        }
      }
    }
  },
  scales: {
    x: {
      stacked: true,
    },
    y: {
      stacked: false,
      title: {
        display: true,
        text: '방문자 수'
      },
      ticks: {
        callback: function(value: any) {
          return value.toLocaleString();
        }
      }
    }
  }
});
</script>