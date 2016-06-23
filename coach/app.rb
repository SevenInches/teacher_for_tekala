# -*- encoding : utf-8 -*-
module Szcgs
  class Coach < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions
    Rabl.register!

  end
end