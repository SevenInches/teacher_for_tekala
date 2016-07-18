# -*- encoding : utf-8 -*-
module Tekala
  class School < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
    Rabl.register!

  end
end