--Impervious Ascension
function c999117.initial_effect(c)
	c:SetUniqueOnField(1,0,999117)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c999117.cost)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c999117.spcon)
	e2:SetCost(c999117.spcost)
	e2:SetTarget(c999117.sptg)
	e2:SetOperation(c999117.spop)
	c:RegisterEffect(e2)
end
function c999117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c999117.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xaedf)
	and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND
end
function c999117.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c999117.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c999117.thfilter(c)
	return c:IsSetCard(0xaedf) and c:GetDefense()==0 and c:IsAbleToHand()
end
function c999117.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c999117.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c999117.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c999117.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c999117.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c999117.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local spc=g:GetFirst()
	local thc=g:GetNext()
	if spc~=e:GetLabelObject() then spc,thc=thc,spc end
	if Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.SendtoHand(thc,nil,REASON_EFFECT)
	end
end