<template>
  <v-app>
    <TopBar :useKilos="useKilos" @unitChange="useKilos = $event" />
    <v-content>
      <v-container>
        <v-layout align-center justify-center row fill-height wrap>
          <v-flex align-center sm6 xs12>
            <UserInputs
              :useKilos="useKilos"
              :stats.sync="stats"
              :gender.sync="gender"
              :inputLifts.sync="inputLifts"
            />
          </v-flex>
          <v-flex sm6 xs12>
            <LiftRank :stats="statsWilks" />
          </v-flex>
        </v-layout>
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
import LiftRank from '@/components/LiftRank.vue'
import { Stat } from '@/models/Stat'

@Component({
  components: {
    TopBar, UserInputs, LiftRank,
  },
})
export default class App extends Vue {
  useKilos: boolean = true
  gender: 'male' | 'female' = 'male'
  inputLifts: boolean = true // Input individual lifts as opposed to just the total

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
   * Returns an array of stats with bodyweight removed and the value replaced with the wilks score.
   */
  get statsWilks(): Stat[] {
    const stats = this.normalisedStats
    const eq = equationValues[this.gender]
    const bw = stats[0].value
    const fstats = stats.filter((x) => x.name !== 'bodyweight')

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

  /**
   * Toggle between inputting lifts individually vs. inputting total directly.
   */
  @Watch('inputLifts')
  toggleInputs() {
    const newStats = this.inputLifts
      ? [{ name: 'squat', value: 0 }, { name: 'bench', value: 0 }, { name: 'deadlift', value: 0 }]
      : [{ name: 'total', value: 0 }]
    this.stats = [this.stats[0], ...newStats]
  }
}

/**
 * The actual wilks score calculation.
 */
const calcWilksScore = (lift: number, bodyweight: number, eqVals: any): number => {
  const w = bodyweight
  const { a, b, c, d, e , f } = eqVals
  const coeff = (500 / (a + b * w + c * w ** 2 + d * w ** 3 + e * w ** 4 + f * w ** 5))
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
