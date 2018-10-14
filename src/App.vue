<template>
  <v-app>
    <TopBar :useKilos="useKilos" @unitChange="useKilos = $event" />
    <v-content>
      <v-container fluid>
        <UserInputs :useKilos="useKilos" :lifts="lifts" @liftsUpdated="lifts = $event" />
        <LiftProportions />
        <LiftRank />
      </v-container>
    </v-content>
    <v-footer app></v-footer>
  </v-app>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import TopBar from '@/components/TopBar.vue'
import UserInputs from '@/components/UserInputs.vue'
import LiftProportions from '@/components/LiftProportions.vue'
import LiftRank from '@/components/LiftRank.vue'
import Lifts from '@/models/Lifts'

@Component({
  components: {
    TopBar, UserInputs, LiftProportions, LiftRank,
  },
})
export default class App extends Vue {
  useKilos: boolean = true

  lifts: Lifts = {
    squat: 0,
    bench: 0,
    deadlift: 0,
  }
}
</script>
