--Impervious Time Capsule
function c999100.initial_effect(c)
	c:SetUniqueOnField(1,0,999100)
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c999100.cost)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999100,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c999100.rmcon)
	e2:SetCost(c999100.cost1)
	e2:SetTarget(c999100.rmtg)
	e2:SetOperation(c999100.rmop)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(999100,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,999100)
	e3:SetCondition(c999100.con)
	e3:SetCost(c999100.cost2)
	e3:SetTarget(c999100.tg)
	e3:SetOperation(c999100.op)
	c:RegisterEffect(e3)
end
function c999100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c999100.confil(c)
	return c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c999100.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999100.confil,tp,LOCATION_DECK,0,1,nil)
end
function c999100.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c999100.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c999100.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED)
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
	end
end
function c999100.tdconfil(c)
	return c:IsFacedown()
end
function c999100.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c999100.tdconfil,tp,LOCATION_REMOVED,0,1,nil)
end
function c999100.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c999100.fil(c,rc)
	return c:IsRelateToCard(rc) and c:IsAbleToHand()
end
function c999100.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999100.fil,tp,LOCATION_REMOVED,0,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	local rec=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)*200
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c999100.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999100.fil,tp,LOCATION_REMOVED,0,nil,c)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local rec=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)*200
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
