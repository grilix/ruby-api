require './test/config'
require './services/users/tokens'

describe Services::Users::Tokens do
  describe '.user_from_token' do
    before do
      @payload = { 'user_id' => 1, 'username' => 'test' }
      @user = Services::Users::Tokens.user_from_token(@payload)
    end

    it 'extracts data' do
      _(@user[:id]).must_equal(1)
    end

    it 'extracts username' do
      _(@user[:username]).must_equal('test')
    end
  end

  describe '.token_from_user' do
    before do
      @payload = { id: 1, username: 'test' }
      @token = Services::Users::Tokens.token_from_user(@payload)
    end

    it 'token can be decoded' do
      decoded = JWT.decode(@token, nil, false)
      _(decoded[0]['user_id']).must_equal(1)
      _(decoded[0]['username']).must_equal('test')
    end

    it 'adds expiration' do
      decoded = JWT.decode(@token, nil, false)
      _(decoded[0]['exp']).must_be_kind_of(Integer)
    end

    it 'adds algorith info' do
      decoded = JWT.decode(@token, nil, false)
      _(decoded[1]['alg']).must_equal('HS256')
    end
  end
end
