--Radiant Slate Warrior
function c999115.initial_effect(c)
	c:SetUniqueOnField(1,0,999115)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999115.altcon)
	e0:SetOperation(c999115.altop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999115,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,999115)
	e1:SetCondition(c999115.condition)
	e1:SetTarget(c999115.target)
	e1:SetOperation(c999115.operation)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68073522,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c999115.reccon)
	e2:SetTarget(c999115.rectg)
	e2:SetOperation(c999115.recop)
	c:RegisterEffect(e2)
end
function c999115.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999115.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999115.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c999115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999115.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c999115.recfil(c)
	return c:IsType(TYPE_MONSTER) and not c:IsCode(999115)
end
function c999115.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c999115.recfil,1,nil)
end
function c999115.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local ct=eg:FilterCount(c999115.recfil,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ct*200)
end
function c999115.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
