<template>
  <v-toolbar color="deep-purple" dark fixed app>
    <v-toolbar-title>Wilks Calculator</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-toolbar-items>
      <v-btn flat @click="toggleUnits">
        Switch to {{ useKilos ? 'LBS' : 'KG' }}
      </v-btn>
    </v-toolbar-items>
  </v-toolbar>
</template>

<script lang="ts">
import { Component, Vue, Prop, Emit } from 'vue-property-decorator'

@Component
export default class TopBar extends Vue {
  @Prop({ type: Boolean, default: true })
  useKilos: boolean = true

  @Emit('unitChange')
  toggleUnits() {
    return !this.useKilos
  }
}
</script>
