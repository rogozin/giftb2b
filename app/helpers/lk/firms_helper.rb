module Lk::FirmsHelper

  def firm_logo_present?
    current_user && current_user.firm && current_user.firm.images.present?
  end
end
