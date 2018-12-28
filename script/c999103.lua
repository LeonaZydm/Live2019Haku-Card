--Durable Slate Warrior
function c999103.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999103.altcon)
	e0:SetOperation(c999103.altop)
	c:RegisterEffect(e0)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999103,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c999103.ntcon)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999103,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,999103)
	e2:SetTarget(c999103.target)
	e2:SetOperation(c999103.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(999103,2))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_RECOVER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetCondition(c999103.atkcon)
	e5:SetOperation(c999103.atkop)
	c:RegisterEffect(e5)
end
function c999103.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999103.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999103.confil(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999103.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c999103.confil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c999103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local rec=Duel.GetMatchingGroupCount(c999103.recfil,tp,LOCATION_ONFIELD,0,nil)*400
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c999103.recfil(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c999103.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rec=Duel.GetMatchingGroupCount(c999103.recfil,tp,LOCATION_ONFIELD,0,nil)*400
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
function c999103.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c999103.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetValue(400)
		c:RegisterEffect(e1)
	end
end
