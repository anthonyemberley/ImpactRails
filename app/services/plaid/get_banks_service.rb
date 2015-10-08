class GetBanksService < Aldous::Service
	BANK_OF_AMERICA_LOGO = "http://about.bankofamerica.com/assets/images/common/bank_logo_256x256.png"
	CITI_BANK_LOGO = "http://images.all-free-download.com/images/graphicthumb/citibank_0_62794.jpg"
	CHASE_LOGO = "https://logo.clearbit.com/chase.com"
	WELLS_FARGO_LOGO = "https://logo.clearbit.com/wellsfargo.com"
	US_BANK_LOGO = "https://logo.clearbit.com/usbank.com"
	USAA_LOGO = "https://logo.clearbit.com/usaa.com"
	CAPITAL_ONE_LOGO = "https://logo.clearbit.com/capitalone.com"
	CHARLES_SCHWAB_LOGO ="https://logo.clearbit.com/schwab.com"
	FIDELITY_LOGO = "https://logo.clearbit.com/fidelity.com"
	PNC_LOGO = "https://logo.clearbit.com/pnc.com"
	TD_BANK_LOGO = "https://logo.clearbit.com/td.com"
	SILICON_VALLEY_BANK_LOGO = "https://logo.clearbit.com/svb.com"
	NAVY_FEDERAL_CREDIT_UNION_LOGO = "https://www.navyfederal.org/assets/images/nfcu-logo-bluegrad-800.jpg"
	SUNTRUST_LOGO = "http://itsthejourney.org/wp-content/uploads/2015/06/SunTrust-Preferred-12-Ray-Logo-4-Color-Process-EPS-01.jpg"
	AMERICAN_EXPRESS_LOGO = "http://www.jonburg.com/.a/6a00e008ddd1088834017ee493a46f970d-800wi"
	def perform
		all_banks = Plaid.institution
		result = Array.new
		all_banks.each do |bank| 
			bank_hash = bank.as_json
			bank_hash["logo_url"] = get_logo(bank)
			result.push(bank_hash)
		end
		if result.any?
			Result::Success.new(result: result)
		else
			Result::Failure.new(errors: "Unable to get banks")
		end
	end

	def get_logo(bank)
		bank_type = bank.type
		logo_url = ""
		case bank_type
		when "bofa"
			logo_url = BANK_OF_AMERICA_LOGO
		when "citi"
			logo_url = CITI_BANK_LOGO
		when "chase"
			logo_url = CHASE_LOGO
		when "wells"
			logo_url = WELLS_FARGO_LOGO
		when "us"
			logo_url = US_BANK_LOGO
		when "usaa"
			logo_url = USAA_LOGO
		when "capone360"
			logo_url = CAPITAL_ONE_LOGO
		when "schwab"
			logo_url = CHARLES_SCHWAB_LOGO
		when "fidelity"
			logo_url = FIDELITY_LOGO
		when "pnc"
			logo_url = PNC_LOGO
		when "svb"
			logo_url = SILICON_VALLEY_BANK_LOGO
		when "td"
			logo_url = TD_BANK_LOGO
		when "nfcu"
			logo_url = NAVY_FEDERAL_CREDIT_UNION_LOGO
		when "suntrust"
			logo_url = SUNTRUST_LOGO
		when "amex"
			logo_url = AMERICAN_EXPRESS_LOGO
		else
			logo_url = "Logo Not Found"
		end
		return logo_url
	end


end