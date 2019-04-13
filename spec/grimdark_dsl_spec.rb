require 'grimdark_dsl'

#
# Test faction Thousand Sons
#
class ThousandSons
  include GrimdarkDsl::Faction

  model 'Rubric Marine' do
    stats M: 5, WS: 3, BS: 3, S: 4, T: 4, W: 1, A: 1, Ld: 7, Sv: 3
    points 16
    ability 'All is Dust'

    subtype 'Gunner' do
      max 1
    end

    type 'Aspiring Sorcerer' do
      stats M: 6, A: 2, Ld: 8
      max 1
      points 17
      remove_ability 'All is Dust'
    end
  end
end

RSpec.describe GrimdarkDsl do
  it 'has a version number' do
    expect(GrimdarkDsl::VERSION).not_to be nil
  end

  it 'does something useful' do
  end
end
