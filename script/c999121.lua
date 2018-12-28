--Dragoneer Slate Warrior
function c999121.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--halve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c999121.altcon)
	e1:SetOperation(c999121.altop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c999121.sprcon)
	e2:SetOperation(c999121.sprop)
	c:RegisterEffect(e2)
	--Cost Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LPCOST_CHANGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c999121.costchange)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(25788011,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(c999121.setcost)
	e4:SetTarget(c999121.settg)
	e4:SetOperation(c999121.setop)
	c:RegisterEffect(e4)
end
function c999121.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999121.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999121.spfilter1(c,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c999121.spfilter2,tp,LOCATION_GRAVE,0,1,c)
end
function c999121.spfilter2(c)
	return c:IsSetCard(0xaedf) and c:GetDefense()==0 and c:IsAbleToDeckOrExtraAsCost()
end
function c999121.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c999121.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c999121.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(999121,0))
	local g1=Duel.SelectMatchingCard(tp,c999121.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(999121,1))
	local g2=Duel.SelectMatchingCard(tp,c999121.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c999121.costchange(e,re,rp,val)
	if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_SPELL) and not re:GetHandler():IsCode(9236985) then
		return 0
	else
		return val
	end
end
function c999121.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c999121.setfil(c)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSSetable()
end
function c999121.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c999121.setfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c999121.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c999121.setfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
