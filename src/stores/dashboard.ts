import { defineStore } from 'pinia'
import { ref } from 'vue'

export interface Order {
  id: string
  customer: string
  product: string
  amount: number
  status: string
}

export interface User {
  id: number
  name: string
  email: string
  avatar: string
}

export const useDashboardStore = defineStore('dashboard', () => {
  // 통계 데이터
  const stats = ref([
    {
      title: '총 사용자',
      value: '12,361',
      change: '+5.2%',
      isPositive: true,
      color: 'primary',
      icon: 'users'
    },
    {
      title: '월간 수익',
      value: '₩324,521,000',
      change: '+8.1%',
      isPositive: true,
      color: 'accent',
      icon: 'cash'
    },
    {
      title: '주문 완료',
      value: '1,243',
      change: '-2.3%',
      isPositive: false,
      color: 'secondary',
      icon: 'shopping-cart'
    },
    {
      title: '방문자',
      value: '21,540',
      change: '+12.6%',
      isPositive: true,
      color: 'info',
      icon: 'chart-bar'
    }
  ])

  // 주문 데이터
  const orders = ref<Order[]>([
    {
      id: '1283',
      customer: '김지민',
      product: '스마트폰',
      amount: 1200000,
      status: '완료'
    },
    {
      id: '1282',
      customer: '이승우',
      product: '노트북',
      amount: 1850000,
      status: '처리중'
    },
    {
      id: '1281',
      customer: '박소연',
      product: '블루투스 이어폰',
      amount: 150000,
      status: '완료'
    },
    {
      id: '1280',
      customer: '정민준',
      product: '태블릿',
      amount: 890000,
      status: '취소'
    },
    {
      id: '1279',
      customer: '최은지',
      product: '스마트워치',
      amount: 320000,
      status: '완료'
    }
  ])

  // 활성 사용자
  const activeUsers = ref<User[]>([
    {
      id: 1,
      name: '김지민',
      email: 'jimin@example.com',
      avatar: '/api/placeholder/40/40'
    },
    {
      id: 2,
      name: '이승우',
      email: 'seungwoo@example.com',
      avatar: '/api/placeholder/40/40'
    },
    {
      id: 3,
      name: '박소연',
      email: 'soyeon@example.com',
      avatar: '/api/placeholder/40/40'
    },
    {
      id: 4,
      name: '정민준',
      email: 'minjun@example.com',
      avatar: '/api/placeholder/40/40'
    }
  ])

  return {
    stats,
    orders,
    activeUsers
  }
})