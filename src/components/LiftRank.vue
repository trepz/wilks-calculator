<template>
  <v-container>

    <v-layout row wrap justify-center="">
      <v-flex xs12 mb-4 class="total-score">
        <strong class="display-1">WILKS: {{ total.toFixed(2) }}</strong><br>
        <span class="subheading">{{ rank(stats) }}</span>
      </v-flex>

      <v-flex 
        sm3 xs12 mb-3 
        v-for="stat in stats" 
        :key="stat.name" 
        v-if="stat.value"
        class="single-lift-score"
      >
        <span>{{ stat.name }}: {{ stat.value.toFixed(2) }}</span><br>
        <small>{{ rank(stat) }}</small>
      </v-flex>
    </v-layout>

  </v-container>
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
   */
  rank(stat: Stat | Stat[]): string {
    const score = this.offsetWilks(Array.isArray(stat) ? stat : [stat])

    if (score < 150) return 'Untrained'
    if (score < 250) return 'Novice'
    if (score < 300) return 'Low Intermediate'
    if (score < 350) return 'Intermediate'
    if (score < 400) return 'High Intermediate'
    if (score < 425) return 'Advanced'
    if (score < 450) return 'High Advanced'
    if (score < 475) return 'Elite'
    if (score < 525) return 'International Elite'
    if (score < 575) return 'World Class'
    if (score < 750) return 'Among the GOAT'
    return 'Ok, you\'re just being dishonest now'
  }

  /**
   * Multiply wilks score by an offset for finding the correct rank of individual or partial lifts.
   *
   * Individual lifts are calculated based on the average % of the total, using a 35/25/40 ratio
   * (this number comes from TSA's analysis of data from the IPF world championships).
   */
  offsetWilks(stats: Stat[]): number {
    const offsetValues: any = {
      squat: 35,
      bench: 25,
      deadlift: 40,
    }

    const score = stats.reduce((a, c) => a += c.value, 0)
    const offset = stats.reduce((a, c) => c.value ? a += offsetValues[c.name] : a, 0)

    if (!offset) return score
    return score * (100 / offset)
  }
}
</script>