<template>
  <div>
    <LineChart
      class="h-full w-full"
      :chartData="chartData"
      :options="chartOptions"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { LineChart } from 'vue-chart-3';
import { Chart, registerables } from 'chart.js';

// Chart.js 컴포넌트 등록
Chart.register(...registerables);

// 차트 데이터
const monthlyRevenue = ref([
  { month: '1월', revenue: 42000000, target: 38000000 },
  { month: '2월', revenue: 52000000, target: 42000000 },
  { month: '3월', revenue: 48000000, target: 45000000 },
  { month: '4월', revenue: 61000000, target: 50000000 },
  { month: '5월', revenue: 64000000, target: 55000000 },
  { month: '6월', revenue: 71000000, target: 60000000 },
  { month: '7월', revenue: 68000000, target: 65000000 },
  { month: '8월', revenue: 73000000, target: 70000000 }
]);

// Chart.js에 맞는 데이터 형식으로 변환
const chartData = computed(() => ({
  labels: monthlyRevenue.value.map(item => item.month),
  datasets: [
    {
      label: '실제 수익',
      backgroundColor: 'rgba(71, 183, 132, 0.2)',
      borderColor: 'rgba(71, 183, 132, 1)',
      data: monthlyRevenue.value.map(item => item.revenue / 1000000),
      tension: 0.4
    },
    {
      label: '목표 수익',
      backgroundColor: 'rgba(53, 162, 235, 0.2)',
      borderColor: 'rgba(53, 162, 235, 1)',
      data: monthlyRevenue.value.map(item => item.target / 1000000),
      borderDash: [5, 5],
      tension: 0.4
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
            label += new Intl.NumberFormat('ko-KR', { 
              style: 'currency', 
              currency: 'KRW',
              maximumFractionDigits: 0,
              notation: 'compact', 
              compactDisplay: 'short' 
            }).format(context.parsed.y) + '백만';
          }
          return label;
        }
      }
    }
  },
  scales: {
    y: {
      ticks: {
        callback: function(value: any) {
          return value + 'M';
        }
      },
      title: {
        display: true,
        text: '매출(백만 원)'
      }
    }
  }
});
</script>