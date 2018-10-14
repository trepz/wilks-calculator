<template>
  <v-toolbar color="deep-purple" dark fixed app>
    <v-toolbar-title>Wilks Calculator</v-toolbar-title>
    <v-spacer></v-spacer>
    <v-toolbar-items>
      <v-switch
        :label="`Units: ${useKilos ? 'KG' : 'LBS'}`"
        v-model="units"
        color="deep-purple lighten-5"
      ></v-switch>
    </v-toolbar-items>
  </v-toolbar>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'

@Component
export default class TopBar extends Vue {
  @Prop({ type: Boolean, default: true })
  useKilos: boolean = true

  get units() {
    return this.useKilos
  }
  set units(val) {
    this.$emit('unitChange', !this.useKilos)
  }
}
</script>

