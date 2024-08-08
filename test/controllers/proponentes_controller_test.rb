require 'test_helper'

class ProponentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proponent = proponents(:one)
  end

  test 'should get index' do
    get proponents_url
    assert_response :success
  end

  test 'should get new' do
    get new_proponent_url
    assert_response :success
  end

  test 'should create proponente' do
    assert_difference('Proponente.count') do
      post proponents_url, params: { proponent: {} }
    end

    assert_redirected_to proponent_url(Proponent.last)
  end

  test 'should show proponente' do
    get proponent_url(@proponent)
    assert_response :success
  end

  test 'should get edit' do
    get edit_proponent_url(@proponent)
    assert_response :success
  end

  test 'should update proponente' do
    patch proponent_url(@proponent), params: { proponente: {} }
    assert_redirected_to proponent_url(@proponent)
  end

  test 'should destroy proponente' do
    assert_difference('Proponente.count', -1) do
      delete proponent_url(@proponent)
    end

    assert_redirected_to proponents_url
  end
end
