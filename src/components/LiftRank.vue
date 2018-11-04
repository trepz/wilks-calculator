<template>
  <div>
    <div v-for="stat in stats" :key="stat.name">
      {{ stat.name }}: {{ stat.value }}
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
}
</script>