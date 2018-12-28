--Fuse Breaker
function c22167850.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(511001265)
	e1:SetCountLimit(1,22167850+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22167850.condition)
	e1:SetTarget(c22167850.target)
	e1:SetOperation(c22167850.activate)
	c:RegisterEffect(e1)
	if not c22167850.global_check then
		c22167850.global_check=true
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(c22167850.atkchk)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22167850.atkchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,419)==0 and Duel.GetFlagEffect(1-tp,419)==0 then
		Duel.CreateToken(tp,419)
		Duel.CreateToken(1-tp,419)
		Duel.RegisterFlagEffect(tp,419,nil,0,1)
		Duel.RegisterFlagEffect(1-tp,419,nil,0,1)
	end
end
function c22167850.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:GetAttack()>=val
end
function c22167850.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22167850.cfilter,1,nil) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c22167850.desfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack() and c:IsDestructable()
end
function c22167850.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(c22167850.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dg:GetSum(Card.GetAttack))
end
function c22167850.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c22167850.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		local sum=dg:GetSum(Card.GetPreviousAttackOnField)
		Duel.Damage(1-tp,sum,REASON_EFFECT)
	end
end
