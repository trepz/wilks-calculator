<template>
  <v-layout align-center justify-center row fill-height>
    <v-flex xs12 md6>
      <v-form>
        <!-- Gender radio input -->
        <v-radio-group :value="gender" @change="updateGender" row>
          <v-radio label="Male" value="male"></v-radio>
          <v-radio label="Female" value="female"></v-radio>
          <span><!-- Empty span fixes alignment bug --></span>
        </v-radio-group>
        <!-- Stats number inputs -->
        <v-text-field
          v-for="(stat, index) in stats"
          :key="index"
          type="number"
          :value="stat.value"
          @input="updateStats(index, $event)"
          :label="label(stat.name)"
        ></v-text-field>
      </v-form>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import { Stat } from '@/models/Stat'

@Component
export default class UserInputs extends Vue {
  @Prop(Boolean)
  useKilos!: boolean

  @Prop(Array)
  stats!: Stat[]

  @Prop(String)
  gender!: string

  // Add the measurement unit to the lift label
  label(tag: string): string {
    return tag + (this.useKilos ? ' (kg)' : ' (lbs)')
  }

  @Emit('update:stats')
  updateStats(index: number, payload: string): Stat[] {
    return this.stats.map((stat: Stat, i: number) => i === index ? { ...stat, value: +payload } : stat)
  }

  @Emit('update:gender')
  updateGender(payload: string): string {
    return payload
  }
}
</script>
