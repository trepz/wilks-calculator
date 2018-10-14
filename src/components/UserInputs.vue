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

  @Emit('update:gender')
  updateGender(payload: string): string {
    return payload
  }
}
</script>
