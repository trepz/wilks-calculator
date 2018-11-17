import { shallowMount } from '@vue/test-utils'
import LiftRank from '@/components/LiftRank.vue'
import { Stat } from '@/models/Stat'

const demoStats: Stat[] = [
  { name: 'squat', value: 150 },
  { name: 'bench', value: 100 },
  { name: 'deadlift', value: 200 },
]

describe('Lift rank component', () => {
  it('renders the total of all the wilks scores it receives', () => {
    const wrapper = shallowMount(LiftRank, {
      propsData: { stats: demoStats },
    })
    expect(wrapper.find('.display-1').text()).toMatch('WILKS: 450')
  })
})
