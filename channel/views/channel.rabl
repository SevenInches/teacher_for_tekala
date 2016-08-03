node(:status) { 'success' }
child(@channel => :data) {
      attributes :id, :name, :address, :contact_phone, :logo
      node(:user_num) { |val| @demo.present? ? '本月已赚' : val.user_num }
      node(:signup_amount) { |val| @demo.present? ? '累计收入' : val.signup_amount  }
      node(:signup_amount) { |val| @demo.present? ? '注册人数' : val.signup_amount  }
      node(:signup_amount) { |val| @demo.present? ? '付款人数' : val.signup_amount  }
      node(:signup_amount) { |val| @demo.present? ? '转化率' : val.signup_amount  }
      # node(:consultant_count) {@consultant_count}
}