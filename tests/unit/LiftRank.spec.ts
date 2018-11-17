import { shallowMount } from '@vue/test-utils'
import LiftRank from '@/components/LiftRank.vue'
import { Stat } from '@/models/Stat'

// Sample stats
const s: Stat = { name: 'squat', value: 150 }
const b: Stat = { name: 'bench', value: 100 }
const d: Stat = { name: 'deadlift', value: 200 }

describe('Total wilks score', () => {
  it('renders the total of all the wilks scores it receives', () => {
    const wrapper = shallowMount(LiftRank, { propsData: { stats: [s, b, d] }})
    expect(wrapper.find('.display-1').text()).toMatch('WILKS: 450')
  })

  it('renders the total correctly from partials', () => {
    const wrapper = shallowMount(LiftRank, { propsData: { stats: [s] }})
    expect(wrapper.find('.display-1').text()).toMatch('WILKS: 150')
  })
})

describe('Individual lift scores', () => {
  it('renders individual scores', () => {
    const wrapper = shallowMount(LiftRank, { propsData: { stats: [s, b, d] }})
    const individualLifts = wrapper.findAll('.single-lift-score')
    expect(individualLifts).toHaveLength(3)
  })

  it('only renders the number of individual stats passed as props', () => {
    const wrapper = shallowMount(LiftRank, { propsData: { stats: [b] }})
    const individualLifts = wrapper.findAll('.single-lift-score')
    expect(individualLifts).toHaveLength(1)
  })

  it('only renders lifts with a value greater than 0', () => {
    const wrapper = shallowMount(LiftRank, { propsData: { stats: [b, { ...s, value: 0 }] }})
    const individualLifts = wrapper.findAll('.single-lift-score')
    expect(individualLifts).toHaveLength(1)
  })

})
