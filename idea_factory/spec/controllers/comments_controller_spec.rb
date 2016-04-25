require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:idea) {Idea.create({ title: "Hello", body: "World!" })}
  let(:user) {User.create({ first_name: "abc", last_name: "xyz", email: "abc@gmail.com", password: "secret", password_confirmation: "secret"})}

  describe "#create" do
    context "without a signed in user" do
      it "redirects to sign up page" do
        post :create, comment: {body: "This idea is great!"}, idea_id: idea.id
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with signed in user" do
      before { request.session[:user_id] = user.id }

      def valid_request
        post :create, comment: {body: "This idea is great!"}, idea_id: idea.id
      end
      it "redirects to idea show page" do
        valid_request
        expect(response).to redirect_to(idea_path(idea))
      end

      it "saves a record to the database" do
        count_before = Comment.count
        valid_request
        count_after = Comment.count
        expect(count_after).to eq(count_before + 1)
      end

      it "associates the created comment with the signed in user" do
        valid_request
        expect(Comment.last.user.id).to eq(session[:user_id])
      end
    end
  end

  describe "#destroy" do
    let(:comment) {Comment.create({body: "This idea is great!", idea_id: idea.id})}
    context "without a signed in user" do
      it "redirects to sign up page" do
        delete :destroy, idea_id: idea.id, id: comment.id
        expect(response).to redirect_to(new_session_path)
      end
    end
    context "with a signed in user" do
      before { request.session[:user_id] = user.id }
      it "removes the comment from the database" do
        comment
        count_before = Comment.count
        delete :destroy, idea_id: idea.id, id: comment.id
        count_after  = Comment.count
        expect(count_after).to eq(count_before - 1)
      end

      it "redirects to the show page" do
        delete :destroy, idea_id: idea.id, id: comment.id
        expect(response).to redirect_to(idea_path(idea))
      end

      # it "lets non-user cannot delete their own comments" do
      #   u2 = User.create({ first_name: "asd", last_name: "qwe", email: "asd@gmail.com", password: "secret", password_confirmation: "secret"})
      #   c2 = Comment.create({body: "This idea is great!!!" idea_id: idea.id, user_id: u2.id})
      #   delete :destroy, idea_id: idea.id, id: c2.id
      #   expect(response).to redirect_to(new_session_path)
      # end

      # it "lets idea owner to delete any comments on their ideas" do
      #   u2 = User.create({ first_name: "asd", last_name: "qwe", email: "asd@gmail.com", password: "secret", password_confirmation: "secret"})
      #   i2 = Idea.create({ title: "Helloo", body: "World" })
      #   u2.comments = Comment.create({body: "This idea is great!!!" idea_id: i2.id})
      #   count_before = Comment.count
      #   delete :destroy, idea_id: i2.id, id: u2.comments.id
      #   count_after  = Comment.count
      #   expect(count_after).to eq(count_before - 1)
      # end
    end
  end
end
