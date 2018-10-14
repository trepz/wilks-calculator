<template>
  <div id="app">
    <TopBar />
    <UserInputs />
    <LiftProportions />
    <LiftRank />
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import TopBar from '@/components/TopBar.vue'
import UserInputs from '@/components/UserInputs.vue'
import LiftProportions from '@/components/LiftProportions.vue'
import LiftRank from '@/components/LiftRank.vue'

@Component({
  components: {
    TopBar, UserInputs, LiftProportions, LiftRank,
  },
})
export default class App extends Vue {}
</script>
