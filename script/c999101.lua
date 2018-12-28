--Solid Slate Warrior
function c999101.initial_effect(c)
	c:SetUniqueOnField(1,0,999101)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999101.altcon)
	e0:SetOperation(c999101.altop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999101,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,999101)
	e1:SetCondition(c999101.condition)
	e1:SetTarget(c999101.target)
	e1:SetOperation(c999101.operation)
	c:RegisterEffect(e1)
	--avoid damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c999101.damval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(999101,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCondition(c999101.reccon)
	e4:SetTarget(c999101.rectg)
	e4:SetOperation(c999101.recop)
	c:RegisterEffect(e4)
end
function c999101.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999101.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999101.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999101.condition(e)
	return Duel.IsExistingMatchingCard(c999101.spfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
function c999101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999101.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c999101.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c999101.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c999101.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,dam)
end
function c999101.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
