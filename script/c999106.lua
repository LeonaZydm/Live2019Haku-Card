--Impervious Castle
function c999106.initial_effect(c)
	c:SetUniqueOnField(1,0,999106)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c999106.cost)
	c:RegisterEffect(e1)
	--LP up
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999106,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c999106.condition)
	e2:SetOperation(c999106.operation)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c999106.atktg)
	e3:SetValue(c999106.atkval)
	c:RegisterEffect(e3)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999106,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RECOVER)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c999106.tdcon)
	e4:SetCost(c999106.tdcost)
	e4:SetTarget(c999106.tdtg)
	e4:SetOperation(c999106.tdop)
	c:RegisterEffect(e4)
end
function c999106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c999106.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) or (re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND))
		and re:GetHandler()~=e:GetHandler() and e:GetHandler():GetFlagEffect(1)>0
end
function c999106.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(e:GetHandlerPlayer(),400,REASON_EFFECT)
end
function c999106.atktg(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c999106.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999106.atkval(e,c)
	return Duel.GetMatchingGroupCount(c999106.cfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*200
end
function c999106.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c999106.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c999106.tdfilter(c)
	return c:IsSetCard(0xaedf) and c:IsDefenseBelow(1025) and c:IsAbleToDeck()
end
function c999106.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c999106.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999106.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c999106.tdfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c999106.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
