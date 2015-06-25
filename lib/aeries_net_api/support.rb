module AeriesNetApi
  module Support
    def blank?
      return true if nil?
      return self.gsub(/\s/, '').length==0 if self.kind_of? String
      return self.empty? if self.respond_to? :empty?
      false
    end

    def present?
      !blank?
    end
  end
end