require 'application_system_test_case'

class ProponentesTest < ApplicationSystemTestCase
  setup do
    @proponente = proponentes(:one)
  end

  test 'visiting the index' do
    visit proponentes_url
    assert_selector 'h1', text: 'Proponentes'
  end

  test 'creating a Proponente' do
    visit proponentes_url
    click_on 'New Proponente'

    click_on 'Create Proponente'

    assert_text 'Proponente was successfully created'
    click_on 'Back'
  end

  test 'updating a Proponente' do
    visit proponentes_url
    click_on 'Edit', match: :first

    click_on 'Update Proponente'

    assert_text 'Proponente was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Proponente' do
    visit proponentes_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Proponente was successfully destroyed'
  end
end
