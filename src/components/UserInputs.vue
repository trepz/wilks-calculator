<template>
  <v-layout align-center justify-center row fill-height>
    <v-flex xs12 md6>
      <v-form>
        <v-text-field
          v-for="stat in Object.keys(stats)"
          :key="stat"
          type="number"
          :value="stats[stat] || ''"
          @input="updateStats(stat, $event)"
          :label="label(stat)"
        ></v-text-field>
      </v-form>
    </v-flex>
  </v-layout>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'
import Stats from '@/models/Stats'

@Component
export default class UserInputs extends Vue {
  @Prop(Boolean)
  useKilos!: boolean

  @Prop({ type: Object as () => Stats })
  stats!: Stats

  @Prop(String)
  gender!: string

  // Add the measurement unit to the lift label
  label(tag: string): string {
    return tag + (this.useKilos ? ' (kg)' : ' (lbs)')
  }

  @Emit('update:stats')
  updateStats(stat: string, payload: string): Stats {
    return { ...this.stats, [stat]: +payload }
  }
}
</script>
