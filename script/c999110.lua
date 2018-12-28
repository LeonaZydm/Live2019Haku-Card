--Lancing Slate Warrior
function c999110.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999110.altcon)
	e0:SetOperation(c999110.altop)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c999110.atkval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999110,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,999110)
	e2:SetTarget(c999110.target)
	e2:SetOperation(c999110.operation)
	c:RegisterEffect(e2)
end
function c999110.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999110.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999110.atkfil(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c999110.atkval(e,c)
	return Duel.GetMatchingGroupCount(c999110.atkfil,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end
function c999110.filter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttackBelow(2300) and not c:IsCode(999110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c999110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and chkc:IsControler(tp) and c999110.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c999110.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c999110.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c999110.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		and Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
