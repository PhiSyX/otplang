defmodule LogLevel do
  def to_label(level, legacy?) do
    cond do
      level == 5 and not legacy?  -> :fatal
      level == 4                  -> :error
      level == 3                  -> :warning
      level == 2                  -> :info
      level == 1                  -> :debug
      level == 0 and not legacy?  -> :trace
      true                        -> :unknown
    end
  end

  def alert_recipient(level, legacy?) do
    log_label = to_label(level, legacy?)

    cond do
      log_label == :error    or     log_label == :fatal -> :ops
      log_label == :unknown and     legacy?             -> :dev1
      log_label == :unknown and not legacy?             -> :dev2
      true                                              -> false
    end
  end
end
