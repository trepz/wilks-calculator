<template>
  <v-app>
    <TopBar :useKilos="useKilos" @unitChange="useKilos = $event" />
    <v-content>
      <v-container fluid>
        <UserInputs
          :useKilos="useKilos"
          :stats.sync="stats"
          :gender.sync="gender"
        />
        <LiftProportions />
        <LiftRank />
      </v-container>
    </v-content>
    <v-footer app></v-footer>
  </v-app>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator'
import * as convert from '@/lib/convert'

import TopBar from '@/components/TopBar.vue'
import UserInputs from '@/components/UserInputs.vue'
import LiftProportions from '@/components/LiftProportions.vue'
import LiftRank from '@/components/LiftRank.vue'
import { Stat } from '@/models/Stat'

@Component({
  components: {
    TopBar, UserInputs, LiftProportions, LiftRank,
  },
})
export default class App extends Vue {
  useKilos: boolean = true
  gender: 'male' | 'female' = 'male'

  /**
   * List of user stats available as inputs. The first stat
   * needs to be bodyweight.
   */
  stats: Stat[] = [
    { name: 'bodyweight', value: 90 },
    { name: 'squat', value: 0 },
    { name: 'bench', value: 0 },
    { name: 'deadlift', value: 0 },
  ]

  /**
   * Returns all the stats in kilograms.
   */
  get normalisedStats(): Stat[] {
    return this.useKilos
      ? this.stats
      : this.stats.map((stat: Stat) => ({ ...stat, value: convert.toKgs(stat.value) }))
  }

  /**
   * Calculate the wilks score of all the users inputs.
   * 
   * Returns an array of stats with bodyweight removed, and adds
   * a new stat which acts as the total of all the other stats.
   */
  get statsWilks(): Stat[] {
    const stats = this.normalisedStats
    const eq = equationValues[this.gender]
    const bw = stats[0].value
    const fstats = stats.filter((x) => x.name !== 'bodyweight')
    const total = fstats.reduce((a, c) => a += c.value, 0)

    return fstats.map((x) => ({ name: x.name, value: calcWilksScore(x.value, bw, eq) }))
  }

  /**
   * Convert the measurement units for all current inputs when the
   * 'useKilos' value is changed.
   */
  @Watch('useKilos')
  convertStats(): void {
    this.stats = this.stats.map((stat: Stat) => {
      const value = this.useKilos ? convert.toKgs(stat.value) : convert.toLbs(stat.value)
      return { ...stat, value }
    })
  }
}

/**
 * The actual wilks score calculation.
 */
const calcWilksScore = (lift: number, bodyweight: number, eqVals: any): number => {
  const p = Math.pow
  const w = bodyweight
  const { a, b, c, d, e , f } = eqVals
  const coeff = (500 / (a + b * w + c * p(w, 2) + d * p(w, 3) + e * p(w, 4) + f * p(w, 5)))
  return lift * coeff
}

/**
 * Equation values for calculating wilks score depending on gender.
 */
const equationValues = {
  male: {
    a: -216.0475144,
    b: 16.2606339,
    c: -0.002388645,
    d: -0.00113732,
    e: 7.01863E-06,
    f: -1.291E-08,
  },
  female: {
    a: 594.31747775582,
    b: -27.23842536447,
    c: 0.82112226871,
    d: -0.00930733913,
    e: 4.731582E-05,
    f: -9.054E-08,
  },
}
</script>
