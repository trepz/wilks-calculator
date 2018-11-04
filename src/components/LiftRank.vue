<template>
  <div>
    <strong>TOTAL: {{ total.toFixed(2) }}</strong>
    <div v-for="stat in stats" :key="stat.name">
      {{ stat.name }}: {{ stat.value.toFixed(2) }}
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import { Stat } from '@/models/Stat'

@Component
export default class LiftRank extends Vue {
  @Prop(Array)
  stats!: Stat[]

  get total(): number {
    return this.stats.reduce((a, c) => a += c.value, 0)
  }
}
</script>