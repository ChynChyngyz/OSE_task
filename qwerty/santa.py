import networkx as nx
import matplotlib.pyplot as plt

n = int(input("Введите количество участников: "))

loyalty = [0] * n
empathy = [0] * n
nodes = list(range(1, n + 1))

for i in range(n):
    loyalty[i] = float(input(f"Лояльность участника {i + 1}: "))
    empathy[i] = int(input(f"Эмпатия участника {i + 1}: "))

G = nx.Graph()

for i in range(n):
    G.add_node(i + 1, loyalty=loyalty[i], empathy=empathy[i])

for i in range(n):
    for j in range(i + 1, n):
        if i != j:
            edge_weight = loyalty[j] * empathy[i]
            G.add_edge(i + 1, j + 1, weight=edge_weight)

sum = sum(edge_data['weight'] for u, v, edge_data in G.edges(data=True))

success = sum / n

print(f"Средний вес рёбер: {success:.2f}")

if success < 5:
    print(f"Неудача {success}")
elif 5<success<7:
    print(f"Норм {success}")
elif 7<success:
    print(f"Идеально {success}")

pos = nx.spring_layout(G)
plt.figure(figsize=(8, 6))
nx.draw(G, pos, with_labels=True, node_color='skyblue', node_size=2000, font_size=12, font_weight='bold')

edge_labels = nx.get_edge_attributes(G, 'weight')
nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels)

plt.title("Граф участников с весами рёбер")
plt.show()