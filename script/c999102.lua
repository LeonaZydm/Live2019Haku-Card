--Striking Slate Warrior
function c999102.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999102.altcon)
	e0:SetOperation(c999102.altop)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999102,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,999102)
	e1:SetCondition(c999102.atkcon)
	e1:SetCost(c999102.atkcost)
	e1:SetOperation(c999102.atkop)
	c:RegisterEffect(e1)
	--protect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999102,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,999102)
	e2:SetCost(c999102.atkcost)
	e2:SetTarget(c999102.proctg)
	e2:SetOperation(c999102.procop)
	c:RegisterEffect(e2)
	--to hand
	local e25=Effect.CreateEffect(c)
	e25:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e25:SetType(EFFECT_TYPE_IGNITION)
	e25:SetRange(LOCATION_MZONE)
	e25:SetTarget(c999102.opttg)
	e25:SetOperation(c999102.optop)
	c:RegisterEffect(e25)
end
function c999102.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999102.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999102.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c999102.optop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Recover(tp,800,REASON_EFFECT)
	end
end
function c999102.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	e:SetLabelObject(c)
	return c and c:IsSetCard(0xaedf) and c:IsRace(RACE_WARRIOR) and c:IsRelateToBattle()
end
function c999102.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c999102.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
	end
end
function c999102.procfil(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999102.proctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999102.procfil,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c999102.procop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c999102.procfil,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c999102.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c999102.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
