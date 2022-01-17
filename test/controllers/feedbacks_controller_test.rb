# frozen_string_literal: true

require 'test_helper'

class FeedbacksControllerTest < ActionDispatch::IntegrationTest
  class Index < FeedbacksControllerTest
    setup do
      sign_in_and_set_encryption users(:two)
    end

    test 'should get index' do
      get feedbacks_url
      assert_response :success
    end
  end

  class Create < FeedbacksControllerTest
    setup do
      sign_in_and_set_encryption users(:two)
    end

    test 'should create feedback with shared_key' do
      post feedbacks_url,
           params: { feedback: {} }

      assert_response :redirect
      assert_not_empty @user.received_feedbacks
      assert_not_empty @user.received_feedbacks.last.shared_key
    end
  end

  class Edit < FeedbacksControllerTest
    class WhenUserDidNotSeeSignInPage < FeedbacksControllerTest
      test 'should redirect to sign_in page' do
        get edit_feedback_url(id: 1)

        assert_response :redirect
      end
    end

    class WhenUserHasSeenSignInPage < FeedbacksControllerTest
      class WhenFeedbackDoesNotExists < FeedbacksControllerTest
        test 'should can edit feedback' do
          get edit_feedback_url(id: 55_665)

          assert_response :redirect
        end
      end

      class WhenFeedbackExists < FeedbacksControllerTest
        # When feedback has already been edited by existing user
        class WhenRespondentExists < FeedbacksControllerTest
          class WhenUserIsConnected < FeedbacksControllerTest
            test 'should redirect when respondent is not equal to current_user' do
              # given
              sign_in_and_set_encryption users(:two)

              # when
              get edit_feedback_url(id: 3)

              # then
              assert_response :redirect
            end

            test 'should can edit when respondent is equal to current_user' do
              # given
              @user = users(:three)
              sign_in @user
              patch encryption_save_url,
                    params: { user: { password: '123456' } }

              # when
              get edit_feedback_url(id: 3)

              # then
              assert_response :success
            end
          end

          class WhenTheUserIsAGuest < FeedbacksControllerTest
            test 'should redirect' do
              get edit_feedback_url(id: 2), params: { external_user: true }

              # then
              assert_response :redirect
            end
          end
        end

        # When feedback has not already been edited by existing user
        class WhenRespondentDoesNotExists < FeedbacksControllerTest
          test 'should redirect when shared_key is invalid' do
            get edit_feedback_url(id: 1), params: { shared_key: 'bad_shared_key', external_user: 'true' }

            assert_response :redirect
          end

          test 'should can edit feedback when shared_key is valid' do
            get edit_feedback_url(id: 1), params: { shared_key: '123456', external_user: 'true' }

            assert_response :success
          end
        end
      end
    end
  end
end
