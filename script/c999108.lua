--Impervious Mirror
function c999108.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c999108.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c999108.cost)
	e1:SetTarget(c999108.target)
	e1:SetOperation(c999108.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999108,2))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,999108)
	e2:SetCost(c999108.reccost)
	e2:SetTarget(c999108.rectg)
	e2:SetOperation(c999108.recop)
	c:RegisterEffect(e2)
end
function c999108.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c999108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c999108.filter(c,ft,e,tp)
	return c:IsSetCard(0xaedf) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c999108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c999108.filter,tp,LOCATION_GRAVE,0,1,nil,ft,e,tp)
	end
end
function c999108.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c999108.filter),tp,LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,aux.Stringid(999108,0),aux.Stringid(999108,1))
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c999108.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c999108.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c999108.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
