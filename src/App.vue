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
import Stat from '@/models/Stat'

@Component({
  components: {
    TopBar, UserInputs, LiftProportions, LiftRank,
  },
})
export default class App extends Vue {
  useKilos: boolean = true
  gender: string = 'male'

  stats: Stat[] = [
    { name: 'bodyweight', value: 90 },
    { name: 'squat', value: 0 },
    { name: 'bench', value: 0 },
    { name: 'deadlift', value: 0 },
  ]

  get normalisedStats(): Stat[] {
    if (this.useKilos) return this.stats
    return this.stats.map((stat: Stat) => ({ ...stat, value: convert.toKgs(stat.value) }))
  }

  @Watch('useKilos')
  convertStats(): void {
    this.stats = this.stats.map((stat: Stat) => {
      const value = this.useKilos ? convert.toKgs(stat.value) : convert.toLbs(stat.value)
      return { ...stat, value }
    })
  }
}

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
