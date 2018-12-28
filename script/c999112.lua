--Solar Slate Warrior
function c999112.initial_effect(c)
	--halve
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e0:SetCondition(c999112.altcon)
	e0:SetOperation(c999112.altop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999112,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,999112)
	e1:SetCost(c999112.cost)
	e1:SetTarget(c999112.target)
	e1:SetOperation(c999112.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999112,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,999112)
	e2:SetCost(c999112.cost)
	e2:SetTarget(c999112.target)
	e2:SetOperation(c999112.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999112,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,999112)
	e3:SetCost(c999112.cost)
	e3:SetTarget(c999112.target2)
	e3:SetOperation(c999112.operation2)
	c:RegisterEffect(e3)
	--to hand
	local e25=Effect.CreateEffect(c)
	e25:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e25:SetType(EFFECT_TYPE_IGNITION)
	e25:SetRange(LOCATION_MZONE)
	e25:SetTarget(c999112.opttg)
	e25:SetOperation(c999112.optop)
	c:RegisterEffect(e25)
end
function c999112.altcon(e,tp,eg,ep,ev,re,r,rp)
	return (ep~=tp and e:GetHandler():GetBattleTarget()~=nil)
		or (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil)
end
function c999112.altop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c999112.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
end
function c999112.optop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Recover(tp,700,REASON_EFFECT)
	end
end
function c999112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c999112.filter(c,tp,ep)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()<=2500
		and ep~=tp and c:IsAbleToRemove()
end
function c999112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return c999112.filter(tc,tp,ep) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c999112.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local lp=0
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()<=2500 then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		lp=lp+tc:GetBaseAttack()/2
		if lp>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,lp,REASON_EFFECT)
		end
	end
end
function c999112.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()<=2500 and c:GetSummonPlayer()~=tp
		and c:IsAbleToRemove()
end
function c999112.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c999112.filter2,1,nil,tp) end
	local g=eg:Filter(c999112.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c999112.filter3(c,e,tp)
	return c:IsFaceup() and c:GetAttack()<=2500 and c:GetSummonPlayer()~=tp
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
end
function c999112.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c999112.filter3,nil,e,tp)
	local lp=0
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
		lp=lp+g:GetBaseAttack()/2
		if lp>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,lp,REASON_EFFECT)
		end
	end
end
function c999112.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c999112.filter3,nil,e,tp)
	local lp=0
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
		local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local atk=0
		while tc do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
			tc=dg:GetNext()
		end
		Duel.Recover(tp,atk/2,REASON_EFFECT)
	end
end

