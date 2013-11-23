# coding: utf-8

class Rent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :price, :type => Integer
  field :postal_code
  field :typology

  TYPOLOGIES = %w{Quarto T0 T1 T2 T3 T4+}

  validates :price, :presence => { :message => 'Preço inválido' },
                    :numericality => { :only_integer => true, :greater_than => 50, :less_than => 20000, :message => 'Preço inválido' }
  validates :postal_code, :presence => { :message => 'Código-postal de Coimbra inválido' }
  validates :typology, :presence => { :message => 'Tipologia inválida' },
                       :inclusion => { :in => TYPOLOGIES, :allow_blank => true, :message => 'Tipologia inválida' }

  belongs_to :postal_code

  default_scope includes(:postal_code)

  delegate :lat, :lng, :latitude, :longitude, :address, :county, :code, :to => :postal_code

  # Gmaps4Rails
  acts_as_gmappable :process_geocoding => false

  def price
    (self[:price].to_f / 100).round(2) if self[:price]
  end

  def price=(new_price)
    price_will_change!
    self[:price] = (new_price.to_f * 100).to_i
  end

  def postal_code_array
    if postal_code
      postal_code.split('-')
    else
      [nil,nil]
    end
  end

  def gmaps4rails_infowindow
    "#{price}&euro; (#{typology})"
  end

end
