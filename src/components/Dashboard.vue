<template>
  <div>
    <!-- 상단 통계 카드 -->
    <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
      <StatCard 
        v-for="(stat, index) in dashboardStore.stats"
        :key="index"
        :title="stat.title" 
        :value="stat.value" 
        :change="stat.change" 
        :isPositive="stat.isPositive" 
        :color="stat.color" 
        :icon="stat.icon" 
      />
    </div>
    
    <!-- 차트 및 대시보드 주요 컨텐츠 -->
    <div class="mt-8 grid gap-6 md:grid-cols-2">
      <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
          <h2 class="card-title">매출 추이</h2>
          <div class="h-80">
            <RevenueChart />
          </div>
        </div>
      </div>
      
      <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
          <h2 class="card-title">방문자 통계</h2>
          <div class="h-80">
            <VisitorsChart />
          </div>
        </div>
      </div>
    </div>
    
    <!-- 최근 활동 및 사용자 목록 -->
    <div class="mt-8 grid gap-6 md:grid-cols-3">
      <div class="card bg-base-100 shadow-xl md:col-span-2">
        <div class="card-body">
          <h2 class="card-title">최근 주문</h2>
          <div class="overflow-x-auto">
            <table class="table table-zebra w-full">
              <thead>
                <tr>
                  <th>주문 ID</th>
                  <th>고객명</th>
                  <th>상품</th>
                  <th>금액</th>
                  <th>상태</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="order in dashboardStore.orders" :key="order.id">
                  <td>#{{ order.id }}</td>
                  <td>{{ order.customer }}</td>
                  <td>{{ order.product }}</td>
                  <td>₩{{ order.amount.toLocaleString() }}</td>
                  <td>
                    <span
                      class="badge"
                      :class="{
                        'badge-success': order.status === '완료',
                        'badge-warning': order.status === '처리중',
                        'badge-error': order.status === '취소'
                      }"
                    >{{ order.status }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="card-actions justify-end">
            <button class="btn btn-primary btn-sm">모든 주문 보기</button>
          </div>
        </div>
      </div>
      
      <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
          <h2 class="card-title">활성 사용자</h2>
          <ul class="space-y-4">
            <li v-for="user in dashboardStore.activeUsers" :key="user.id" class="flex items-center gap-4">
              <div class="avatar">
                <div class="w-10 rounded-full">
                  <img :src="user.avatar" alt="사용자 프로필" />
                </div>
              </div>
              <div>
                <div class="font-semibold">{{ user.name }}</div>
                <div class="text-sm text-base-content/70">{{ user.email }}</div>
              </div>
              <div class="ml-auto">
                <span class="badge badge-success"></span>
              </div>
            </li>
          </ul>
          <div class="card-actions justify-end">
            <button class="btn btn-primary btn-sm">모든 사용자 보기</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useDashboardStore } from '@/stores/dashboard';
import StatCard from './StatCard.vue';
import RevenueChart from './RevenueChart.vue';
import VisitorsChart from './VisitorsChart.vue';

const dashboardStore = useDashboardStore();

onMounted(() => {
  // 필요한 경우 여기서 데이터를 로드할 수 있습니다
  console.log('Dashboard component mounted');
});
</script>