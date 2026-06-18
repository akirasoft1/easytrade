using EasyTrade.BrokerService.Helpers;

namespace EasyTrade.BrokerService.Test.Fakes;

public class FakeTransactionalRepository : ITransactionalRepository
{
    // Number of times SaveChanges has been called on this repository instance.
    // Used to assert commit behavior (e.g. that callers do not commit once per item).
    public int SaveChangesCallCount { get; private set; }

    public Task BeginTransaction() => Task.CompletedTask;

    public Task CommitTransaction() => Task.CompletedTask;

    public Task RollbackTransaction() => Task.CompletedTask;

    public Task SaveChanges()
    {
        SaveChangesCallCount++;
        return Task.CompletedTask;
    }
}
