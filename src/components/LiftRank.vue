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

  /**
   * Calculate the users estimated competitive level from their wilks score.
   * This is roughly based on a combination of the classic Russian grading
   * tables, the old USPA strength standards, and Greg Nuckols strength standards.
   *
   * Individual lifts are calculated based on the average % of the total, using a 35/25/40 ratio
   * (this number comes from TSA's analysis of data from the IPF world championships).
   */
  rank(stat: Stat): string {
    const offset: any = {
      squat: 100 / 35,
      bench: 100 / 25,
      deadlift: 100 / 40,
    }

    let score = stat.value
    if (Object.keys(offset).includes(stat.name)) {
      score *= offset[stat.name]
    }

    if (score < 150) return 'Untrained'
    if (score < 250) return 'Novice'
    if (score < 300) return 'Low Intermediate'
    if (score < 350) return 'Intermediate'
    if (score < 400) return 'High Intermediate'
    if (score < 425) return 'Advanced (locally competitive)'
    if (score < 450) return 'High Advanced (nationally competitive)'
    if (score < 475) return 'Elite'
    if (score < 525) return 'International Elite'
    if (score < 575) return 'World Class'
    if (score < 750) return 'Among the GOAT'
    return 'Ok, you\'re just being dishonest now'
  }
}
</script>