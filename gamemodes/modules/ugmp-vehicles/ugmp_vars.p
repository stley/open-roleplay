enum ugmp_vehicle_models{
    realModel,
    backendModel,
    fxtname[32]
}
#define MAX_CUSTOM_MODELS   (100)
new custom[][ugmp_vehicle_models] =
{
    {6697, 597, "LCPD Stanier"},
    {6027, 427, "VCPD Enforcer"}
};
enum alloc_models{
    realModel,
    backendModel,
    alloc_vID,
    fxtname[32]
}
#define MAX_CURRENT_MODELS (200)
new allocated_models[MAX_CURRENT_MODELS][alloc_models];