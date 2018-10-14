<template>
  <v-layout align-center justify-center row fill-height>
    <v-flex xs12 md6>
      <v-form>
        <v-text-field
          :value="lifts.squat"
          :label="label('Squat')"
        ></v-text-field>
        <v-text-field
          :value="lifts.bench"
          :label="label('Bench')"
        ></v-text-field>
        <v-text-field
          :value="lifts.deadlift"
          :label="label('Deadlift')"
        ></v-text-field>
      </v-form>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'

@Component
export default class App extends Vue {
  @Prop(Boolean)
  useKilos!: boolean

  @Prop(Object)
  lifts!: object

  label(tag: string): string {
    return tag + (this.useKilos ? ' (kg)' : ' (lbs)')
  }
}
</script>
