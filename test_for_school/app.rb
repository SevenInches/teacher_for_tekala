# -*- encoding : utf-8 -*-
module Tekala
  class TestForSchool < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
    Rabl.register!

  end
end