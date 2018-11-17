import { shallowMount } from '@vue/test-utils'
import LiftRank from '@/components/LiftRank.vue'
import { Stat } from '@/models/Stat'


const s: Stat = { name: 'squat', value: 150 }
const b: Stat = { name: 'bench', value: 100 }
const d: Stat = { name: 'deadlift', value: 200 }


describe('Lift rank component', () => {
  it('renders the total of all the wilks scores it receives', () => {
    const wrapper = shallowMount(LiftRank, {
      propsData: { stats: [s, b, d] },
    })
    expect(wrapper.find('.display-1').text()).toMatch('WILKS: 450')
  })
})
