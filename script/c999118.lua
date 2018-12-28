--Riding Slate Warrior
function c999118.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999118.altcon)
	e0:SetOperation(c999118.altop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999118,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,999118)
	e1:SetCondition(c999118.spcon)
	e1:SetTarget(c999118.sptg)
	e1:SetOperation(c999118.spop)
	c:RegisterEffect(e1)
	--to hand
	local e25=Effect.CreateEffect(c)
	e25:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e25:SetType(EFFECT_TYPE_IGNITION)
	e25:SetRange(LOCATION_MZONE)
	e25:SetTarget(c999118.opttg)
	e25:SetOperation(c999118.optop)
	c:RegisterEffect(e25)
end
function c999118.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999118.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999118.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,925)
end
function c999118.optop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Recover(tp,925,REASON_EFFECT)
	end
end
function c999118.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c999118.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999118.setfil(c)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSSetable()
end
function c999118.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(c999118.setfil,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(999118,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
		end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c999118.atlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c999118.atlimit(e,c)
	return c~=e:GetHandler()
end
