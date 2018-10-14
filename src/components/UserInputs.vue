<template>
  <v-layout align-center justify-center row fill-height>
    <v-flex xs12 md6>
      <v-form>
        <v-text-field
          v-for="lift in Object.keys(lifts)"
          :key="lift"
          type="number"
          :value="lifts[lift] || ''"
          @input="updateLifts(lift, $event)"
          :label="label(lift)"
        ></v-text-field>
      </v-form>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import Lifts from '@/models/Lifts'

@Component
export default class UserInputs extends Vue {
  @Prop(Boolean)
  useKilos!: boolean

  @Prop({ type: Object as () => Lifts })
  lifts!: Lifts

  // Add the measurement unit to the lift label
  label(tag: string): string {
    return tag + (this.useKilos ? ' (kg)' : ' (lbs)')
  }

  @Emit('liftsUpdated')
  updateLifts(lift: string, payload: string): Lifts {
    return { ...this.lifts, [lift]: +payload }
  }
}
</script>
